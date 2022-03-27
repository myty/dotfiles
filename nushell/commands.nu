
def "gam" [] {
    git add .; git commit --amend
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