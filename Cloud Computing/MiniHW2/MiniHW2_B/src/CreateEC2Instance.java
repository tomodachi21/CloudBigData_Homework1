/*
 * Copyright 2010-2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * 
 * Used Base Project File: Create SecurityGroup from AWS Tutorial
 */

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Collections;
import java.util.List;

import com.amazonaws.AmazonClientException;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.PropertiesCredentials;
import com.amazonaws.auth.profile.ProfileCredentialsProvider;
import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.ec2.model.KeyPair;
import com.amazonaws.services.ec2.AmazonEC2;
import com.amazonaws.services.ec2.AmazonEC2Client;
import com.amazonaws.services.ec2.model.AuthorizeSecurityGroupIngressRequest;
import com.amazonaws.services.ec2.model.CreateKeyPairRequest;
import com.amazonaws.services.ec2.model.CreateKeyPairResult;
import com.amazonaws.services.ec2.model.CreateSecurityGroupRequest;
import com.amazonaws.services.ec2.model.CreateSecurityGroupResult;
import com.amazonaws.services.ec2.model.IpPermission;
import com.amazonaws.services.ec2.model.RunInstancesRequest;
import com.amazonaws.services.ec2.model.RunInstancesResult;

public class CreateEC2Instance {

    public static void main(String[] args) {

        /*
         * The ProfileCredentialsProvider will return your [ec2-user]
         * credential profile by reading from the credentials file located at
         * (/Users/eric/.aws/credentials).
         */
        AWSCredentials credentials = null;
        try {
            credentials = new ProfileCredentialsProvider("ec2-user").getCredentials();
        } catch (Exception e) {
            throw new AmazonClientException(
                    "Cannot load the credentials from the credential profiles file. " +
                    "Please make sure that your credentials file is at the correct " +
                    "location (/Users/eric/.aws/credentials), and is in valid format.",
                    e);
        }

        // Create the AmazonEC2Client object so we can call various APIs.
        AmazonEC2 ec2 = new AmazonEC2Client(credentials);
        Region usWest2 = Region.getRegion(Regions.US_WEST_2);
        ec2.setRegion(usWest2);

        // New Code: Create Key-Pair for new AWS Instance on this machine (Macbook Pro)
        ec2.setEndpoint("ec2.us-west-2.amazonaws.com");
        
        CreateKeyPairRequest createKeyPairRequest = new CreateKeyPairRequest();
        createKeyPairRequest.withKeyName("programatic-Java-key-AWS");
        CreateKeyPairResult createKeyPairResult = ec2.createKeyPair(createKeyPairRequest);

        KeyPair keyPair = new KeyPair();
        keyPair = createKeyPairResult.getKeyPair();
        String privateKey = keyPair.getKeyMaterial();
        System.out.println(privateKey);
        
        // AWS Provided Code to create a new security group.
        try {
            CreateSecurityGroupRequest securityGroupRequest = new CreateSecurityGroupRequest(
                    "programatic-Java-Sec-Group", "Security Group Created in Java");
            CreateSecurityGroupResult result = ec2
                    .createSecurityGroup(securityGroupRequest);
            System.out.println(String.format("Security group created: [%s]",
                    result.getGroupId()));
        } catch (AmazonServiceException ase) {
            // Likely this means that the group is already created, so ignore.
            System.out.println(ase.getMessage());
        }

        String ipAddr = "0.0.0.0/0";

        // AWS Provided Code to get the IP of the current host, so that we can limit the Security Group
        try {
            InetAddress addr = InetAddress.getLocalHost();

            // Get IP Address
            ipAddr = addr.getHostAddress()+"/10";
        } catch (UnknownHostException e) {
        }

        
        // Create a range that you would like to populate.
        List<String> ipRanges = Collections.singletonList(ipAddr);

        // Open up port 22 for TCP traffic to the associated IP from above (e.g. ssh traffic).
        IpPermission ipPermission = new IpPermission()
                .withIpProtocol("tcp")
                .withFromPort(new Integer(22))
                .withToPort(new Integer(22))
                .withIpRanges(ipRanges);

        List<IpPermission> ipPermissions = Collections.singletonList(ipPermission);
        try {
            // Authorize the ports to the used.
            AuthorizeSecurityGroupIngressRequest ingressRequest = new AuthorizeSecurityGroupIngressRequest(
                    "programatic-Java-Sec-Group", ipPermissions);
            ec2.authorizeSecurityGroupIngress(ingressRequest);
            System.out.println(String.format("Ingress port authroized: [%s]",
                    ipPermissions.toString()));
        } catch (AmazonServiceException ase) {
            // Ignore because this likely means the zone has already been authorized.
            System.out.println(ase.getMessage());
        }
        
        RunInstancesRequest runInstancesRequest = new RunInstancesRequest();

        runInstancesRequest.withImageId("ami-f0091d91")
        	                     .withInstanceType("t2.small")
        	                     .withMinCount(1)
        	                     .withMaxCount(1)
        	                     .withKeyName("programatic-Java-key-AWS")
        	                     .withSecurityGroups("programatic-Java-Sec-Group");
        	  
         RunInstancesResult runInstancesResult = ec2.runInstances(runInstancesRequest);
        	
    }
}
    