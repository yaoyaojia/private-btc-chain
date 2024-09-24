FROM bitcoin/bitcoin:latest

COPY ./generate_blocks.sh /home/bitcoin

ENTRYPOINT ["bash", "/home/bitcoin/generate_blocks.sh"]
