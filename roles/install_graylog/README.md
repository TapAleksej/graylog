Сетку можно в композе

networks:
  graylognet:
#    driver: brige
    driver_opts:
      com.docker.network.bridge.host_binding_ipv4: "127.0.0.1"
