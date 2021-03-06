// tag::copyright[]
/*******************************************************************************
 * Copyright (c) 2018, 2021 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - Initial implementation
 *******************************************************************************/
// end::copyright[]
package it.io.openliberty.guides.system;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLSession;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.Feature;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.Response;

import org.apache.cxf.jaxrs.client.ClientProperties;
import org.apache.cxf.jaxrs.provider.jsrjsonp.JsrJsonpProvider;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import io.openliberty.guides.system.SystemResource;

public class SystemEndpointIT {

    private static String clusterUrl;
    private static String serviceHost;

    private Client client;
    private Response response;

    @BeforeAll
    public static void oneTimeSetup() {
        String sysRootPath = System.getProperty("system.service.root");
        String hostService = System.getProperty("system.service.host");
        serviceHost = hostService;
        clusterUrl = "http://" + sysRootPath + "/system/properties/";
    }

    @BeforeEach
    public void setup() {
        response = null;
        
        client = ClientBuilder.newBuilder()
                    .hostnameVerifier(new HostnameVerifier() {
                        public boolean verify(String hostname, SSLSession session) {
                            return true;
                        }
                    })
                    .build();
    }

    @AfterEach
    public void teardown() {
        client.close();
    }

    @Test
    public void testPodNameNotNull() {
        response = this.getResponse(clusterUrl);
        this.assertResponse(clusterUrl, response);
        String greeting = response.getHeaderString("X-Pod-Name");

        assertNotNull(greeting, "Container name should not be null. "
            + "The service is probably not running inside a container");
    }

    @Test
    public void testAppVersion() {
        response = this.getResponse(clusterUrl);
        String expectedVersion = SystemResource.APP_VERSION;
        String actualVersion = response.getHeaderString("X-App-Version");

        //assertEquals(expectedVersion, actualVersion);
    }

    @Test
    public void testGetProperties() {
        Client client = ClientBuilder.newClient();
        client.register(JsrJsonpProvider.class);

        WebTarget target = client.target(clusterUrl);
        Response response = target.request().get();

        assertEquals(200, response.getStatus(),
            "Incorrect response code from " + clusterUrl);
        response.close();
    }

    /**
     * <p>
     * Returns response information from the specified URL.
     * </p>
     *
     * @param url
     *          - target URL.
     * @return Response object with the response from the specified URL.
     */
    private Response getResponse(String url) {
        javax.ws.rs.client.Invocation.Builder buildRequest = client
            .target(url)
            .request()
            .header(HttpHeaders.HOST, serviceHost);
        
        //System.out.println("Request sent: "+buildRequest.toString());
        
        return buildRequest
            .get();
    }

    /**
     * <p>
     * Asserts that the given URL has the correct response code of 200.
     * </p>
     *
     * @param url
     *          - target URL.
     * @param response
     *          - response received from the target URL.
     */
    private void assertResponse(String url, Response response) {
        assertEquals(200, response.getStatus(), "Incorrect response code from " + url );
    }

}
