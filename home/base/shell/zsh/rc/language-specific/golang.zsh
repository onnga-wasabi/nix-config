# PATH
## Golang
export GOPATH=$(go env GOPATH)
export PATH="$PATH:${GOPATH}/bin"

# go install するツールが動かないことがある
# こんなの初見無理ゲーすぎる
# https://note.sarisia.cc/entry/linuxbrew-go/#fnref:1:~:text=Go%20%E3%82%B3%E3%83%B3%E3%83%91%E3%82%A4%E3%83%A9%E3%81%AF%E3%80%81%E3%83%87%E3%83%95%E3%82%A9%E3%83%AB%E3%83%88%E3%81%A7%E3%82%B9%E3%82%BF%E3%83%86%E3%82%A3%E3%83%83%E3%82%AF%E3%83%AA%E3%83%B3%E3%82%AF%E3%81%95%E3%82%8C%E3%81%9F%E3%83%90%E3%82%A4%E3%83%8A%E3%83%AA%E3%82%92%E5%90%90%E3%81%8D%E5%87%BA%E3%81%99%E3%81%8C%E3%80%81%20cgo%20%E3%82%92%E7%94%A8%E3%81%84%E3%81%9F%E3%82%B3%E3%83%BC%E3%83%89%E3%81%8C%E5%90%AB%E3%81%BE%E3%82%8C%E3%81%A6%E3%81%84%E3%82%8B%E3%81%A8%E3%83%80%E3%82%A4%E3%83%8A%E3%83%9F%E3%83%83%E3%82%AF%E3%83%AA%E3%83%B3%E3%82%AF%E3%81%95%E3%82%8C%E3%81%9F%E3%83%90%E3%82%A4%E3%83%8A%E3%83%AA%E3%82%92%E5%87%BA%E5%8A%9B%E3%81%99%E3%82%8B%E3%82%89%E3%81%97%E3%81%841%E3%80%82
export CGO_ENABLED=0

