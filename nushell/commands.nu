def gam [] {
  git commit --amend --no-edit --all
}

def gpr [] {
  git pull --rebase
}

def dadjoke [] {
  http get https://icanhazdadjoke.com --headers [Accept text/plain]
}
