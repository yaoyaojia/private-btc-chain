FROM alpine:latest
RUN apk add --no-cache curl jq bash
COPY bitcoin_rpc.sh /home/bitcoin_rpc.sh
ENTRYPOINT ["/bin/bash", "/home/bitcoin_rpc.sh"]
