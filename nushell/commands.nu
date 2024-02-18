def "gam" [] {
    git add .; git commit --amend --no-edit
}

def "gpr" [] {
    git pull; git rebase
}

def "dadjoke" [] {
    curl https://icanhazdadjoke.com -H "Accept: text/plain"
}

def bup [] {
    brew update; brew upgrade; brew cleanup
}

def "git gone" [] {
    # gently try to delete merged branches, excluding the checked out one
    git branch --merged | lines | where $it !~ '\*' | str trim | where $it != 'master' and $it != 'main' | each { |it| git branch -d $it }
}
