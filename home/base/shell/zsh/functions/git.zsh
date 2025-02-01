gcl() {
    local branch
    if [[ $1 ]] then;
        branch=$1
    else
        branch="main"
    fi
    git co ${branch} && git pl ${branch} && git branch --merged | grep -v ${branch} | xargs -I{} git branch -D {}
}
