
package com.example;

import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpExchange;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public class App {

    public static void main(String[] args) throws IOException {

        HttpServer server = HttpServer.create(
            new InetSocketAddress(8080), 0
        );

        server.createContext("/api/hello", exchange -> {

            String response = """
                {
                    "message": "Hello from Java Microservice! This is vaishnavi. checking if the jenkins pipeline is working or not!!",
                    "status": "Success"
                }
                """;

            exchange.getResponseHeaders()
                    .set("Content-Type", "application/json");

            byte[] responseBytes = response.getBytes();

            exchange.sendResponseHeaders(
                200, responseBytes.length
            );

            try (OutputStream output =
                     exchange.getResponseBody()) {

                output.write(responseBytes);
            }
        });

        server.start();

        System.out.println(
            "Java Microservice started on port 8080"
        );
    }
}
