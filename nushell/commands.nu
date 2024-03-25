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
    git for-each-ref --format '%(refname:short) %(upstream:track)' refs/heads | lines | where $it ends-with '[gone]' | str substring ..-7 | each { |it| git branch -D $it } | ignore
}
