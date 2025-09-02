# devops-assesment
Assesment for assetrix devops specialist role
# SSl/tls implementation

## SSL/TLS ON LINODE (VM)

Tools/ services- Use Certbot + Nginx as reverse proxy ( I typically set this up using ansible configration management an example setup is added on the repo).

Automatic renewal- Automate with a cron job: certbot renew --quiet for certificate renewal.

Redirect HTTP→HTTPS with Nginx config (added in the nginx config set up allong with proxy_pass and other setups).

Enforce HSTS with Strict-Transport-Security header. i.e add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;


## SSL/TLS ON AWS

### Tools / Services

AWS Certificate Manager (ACM) for SSL/TLS certificates.

Application Load Balancer (ALB) or CloudFront for HTTPS termination.

### Configuration Steps

Request a certificate in ACM:

Go to ACM Console → Request Public Certificate → Add domain names.

Validate domain ownership via DNS or email.

Attach the certificate to an ALB or CloudFront distribution.

Configure ALB listener rules:

Port 443: Forward traffic to your target group (EC2, ECS, etc.).

Port 80: Redirect traffic to HTTPS (443).

N/B - ACM automatically renews certificates before expiration.

No manual intervention is required once validation is complete.

### Ongoing Security

Enforce atleast TLS 1.2 in ALB security policies:

Redirect HTTP → HTTPS via ALB rule.

Enable HSTS at the application level (e.g., add header in Express or Nginx).

Set up CloudWatch Alarms (the AWS security tools i talked about) to monitor certificate expiry or HTTPS health checks.

Regularly review AWS Security Hub recommendations.
