---
layout: post
title: Understanding and Deploying Cisco SD-WAN (BRKRST-2767)
categories: Networking
subcategories: SD-WAN
permalink: /understanding-and-deploying-cisco-sd-wan
---
## Device roles
   
  * vManage - interface for login to the system, configure, monitor and troubleshoot it;
  * vSmart Controllers - brains of the operation. Policies configured on vManage pushed down to vSmart Controllers; 
  * vBond - tool for ZTP, it instruct routers how to join the network;
  * On-Site routers ([vEdge][1] or Cisco ASR/ISR 1k/4k in 2018).

## Concepts
Overlay Management Protocol (OMP) - TCP based control protocol, creates a peering relationships between vEdge routers and vSmart Controllers over the TLS/DTLS tunnels and used to exchange policies and routes.

At the same time BFD used to provide health checks of the network (DSCP CS6 now and different DSCP values to simulate specific protocols in future implementations). 

Transport Locators (TLOCs) - identifiers of vEdge routers and vSmart Controllers.

<!---excerpt-break-->

## Fabric Operation Walk-Through

  1. TLS/DTLS tunnels created between vEdge routers and vSmart Controllers;
  2. vEdge routers discover other vEdge routers TLOCs via OMP;
  3. vEdge routers build IPSec tunnels with BFD to other vEdge routers;

## Zero Touch Provisioning

  1. vEdge router boots up and send query to ztp.viptela.com;
  2. ztp.viptela.com redirects vEdge to corporate orchestartor (vBond);
  3. vEdge establishes a connection with vBond, downloads initial configuration from vManage and registered on it;

## Useful Links
  * [Cisco Live Presentation][2]
  * [Cisco dCloud Demo "Cisco 4D SD-WAN (Viptela) v1"][3]
  * [Viptela official site][4]
  
 [1]: http://viptela.com/vedge-cloud-datasheet/
 [2]: https://www.ciscolive.com/global/on-demand-library/?search=viptela#/session/15064839297820012EYM 
 [3]: https://dcloud-cms.cisco.com/demo/4d-viptela-v1
 [4]: http://viptela.com/sd-wan/
