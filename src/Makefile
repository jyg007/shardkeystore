all: shardkeystore

deps = ep11/types.go ep11/error.go  ep11/params.go ep11/hsminit.go ep11/ep11.go ep11/constants.go

shardkeystore: shardkeystore.go
	CGO_ENABLED=1 GOOS=linux GOARCH=s390x go build -ldflags="-s -w" -o  shardkeystore shardkeystore.go


