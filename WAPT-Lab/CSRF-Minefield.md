# Welcome to CSRF Minefield!

CSRF Minefield is an Ubuntu Server 18.04 based virtual machine, that is heavily ridden with Cross-Site Request Forgery (CSRF) vulnerabilities. This VM hosts 11 real-world web applications that were found vulnerable to CSRF vulnerability and your aim is to find them and detonate them before they explode the target network.

## What is CSRF?

Cross-Site Request Forgery (CSRF) is an attack that forces an end user to execute unwanted actions on a web application in which they're currently authenticated. CSRF attacks specifically target state-changing requests, not theft of data, since the attacker has no way to see the response to the forged request.  - [OWASP](https://www.owasp.org/index.php/Cross-Site_Request_Forgery_(CSRF))

## How to find or test for a CSRF vulnerability?

As a starting point, you can use the following resources by the OWASP Project:

[OWASP Testing Guide](https://www.owasp.org/index.php/Category:OWASP_Testing_Project)
[OWASP Code Review Guide](https://www.owasp.org/index.php/Category:OWASP_Code_Review_Project)

## List of Web applications included in this version of CSRF Minefield (along with access details):

1. Bolt CMS 3.6.6 
   - http://192.168.126.162/bolt | Username:admin Password:admin123
2. PilusCart 1.4.1 
   - http://192.168.126.162/pilus | Username:admin Password:admin123
3. zzzphp CMS 1.6.1 
   - http://192.168.126.162/zzzphp | Admin link: http://192.168.126.162/zzzphp/admin537/login.php | Username:admin Password:admin123
4. CMSSite 1.0 
   - http://192.168.126.162/cmssite/ | Username:victor Password:victor
5. OOP CMS Blog 1.0 
   - http://192.168.126.162/oop/ | Admin link: http://192.168.126.162/oop/admin | Username:admin Password:123
6. Integria IMS 5.0.83 
   - http://192.168.126.162/integriaims/ | Username:admin Password:integria
7. ZeusCart 4.0 
   - http://192.168.126.162/zeuscart/ | Admin link: http://192.168.126.162/zeuscart/admin | Username:admin Password:admin123
8. WSTMart 2.0.8 
   - http://192.168.126.162/wstmart/ | Admin link: http://192.168.126.162/wstmart/admin.php | Username:admin Password:admin123
9. Simple Online Hotel Reservation System 
   - http://192.168.126.162/hotelcal | Admin link: http://192.168.126.162/hotelcal/admin | Username:admin Password:admin
10. OrientDB 3.0.17 GA Community Edition 
   - Command to start web app:/opt/orient/bin/server.sh | http://192.168.126.162:2480/studio/index.html | Username:root Password:toor
11. Apache CouchDB 2.3.1
   - Command to start web app:/opt/couchdb/bin/couchdb | http://192.168.126.162:5984/_utils/index.html | Username:root Password:toor

## How to get started?

1. Download the VM [from here](https://drive.google.com/file/d/1_PMlOsXkfl_2NuLhtoSu6ewHcNLKoje5/view?usp=sharing) and extract the Zip file.
2. Import / Open OVF with VMWare Player or VMWare Workstation
3. Run the VM
4. Access the VM on IP address 192.168.126.162
5. VM login details: 
   - Username: ptlab
   - Password: ptlab
   - To login as root: sudo su  //(password same as above)
6. Start hunting!
7. There might be a few vulnerabilities of other kind. Let's see if you can find them as well.

In case you run into any troubles, contact me on @yaksas443 (twitter) or csc[at]yaksas[dot]in

May the force be with you!

# ---------------SPOILERS AHEAD!!--------------------

Credits (vulnerability researchers):

1. Bolt CMS 3.6.6 - [FelipeGaspar](https://www.exploit-db.com/exploits/46664)
2. PilusCart 1.4.1 - [Gionathan Reale](https://www.exploit-db.com/exploits/46531)
3. zzzphp CMS 1.6.1 - [Yang Chenglong](https://www.exploit-db.com/exploits/46488)
4. CMSSite 1.0 - [Mr Winst0n](https://www.exploit-db.com/exploits/46480) 
5. OOP CMS Blog 1.0 - [Mr Winst0n](https://www.exploit-db.com/exploits/46483)
6. Integria IMS 5.0.83 - [Javier Olmedo](https://www.exploit-db.com/exploits/46013)
7. ZeusCart 4.0 - [mqt](https://www.exploit-db.com/exploits/46027)
8. WSTMart 2.0.8 - [linfeng](https://www.exploit-db.com/exploits/46036)
9. Simple Online Hotel Reservation System - [Mr Winst0n](https://www.exploit-db.com/exploits/46463)
10. OrientDB 3.0.17 GA Community Edition - [Ozer Goker](https://www.exploit-db.com/exploits/46517)
11. Apache CouchDB 2.3.1 - [Ozer Goker](https://www.exploit-db.com/exploits/46595)
