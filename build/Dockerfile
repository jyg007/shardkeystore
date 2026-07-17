FROM gcr.io/distroless/cc-debian12

# Copy prebuilt Go binary
COPY ./signer4mpc /usr/local/bin/signer4mpc

# Copy IBM EP11 library (if you ship it inside container)
COPY ./libep11.so.4.1.2 /lib/libep11.so.4

# Run as non-root
USER nonroot:nonroot
ENTRYPOINT ["/usr/local/bin/signer4mpc"]

