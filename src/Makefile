all: signer4mpc

deps = ep11/types.go ep11/error.go  ep11/params.go ep11/hsminit.go ep11/ep11.go ep11/constants.go

signer4mpc: signer4mpc.go
	CGO_ENABLED=1 GOOS=linux GOARCH=s390x go build -ldflags="-s -w" -o  signer4mpc signer4mpc.go


