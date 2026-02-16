# 1️⃣ Official AWS Documentation

AWS maintains a full list of **configuration option namespaces and option names**.

🔗 Go to:

> AWS Docs → Elastic Beanstalk → Configuration options

Search:

```
Elastic Beanstalk configuration options namespace
```

You’ll see tables like:

* `aws:autoscaling:asg`
* `aws:elasticbeanstalk:environment`
* `aws:ec2:vpc`
* `aws:elb:listener`
* `aws:elbv2:listener`
* `aws:autoscaling:launchconfiguration`
* `aws:elasticbeanstalk:application:environment`

Each option includes:

* Namespace
* Name
* Default value
* Allowed values
* Description

This is the authoritative source.

---

# 2️⃣ Use AWS CLI

This is the **most accurate method** for your specific platform (AL2 / AL2023 / Java / Node / etc.).

Run:

```bash
aws elasticbeanstalk describe-configuration-settings \
  --application-name dop-practise-eb-app \
  --environment-name dop-practise-eb-env  \ 
  --profile terraform-admin \
  --region ap-southeast-1
  > eb-config-options.json
```

OR for platform-specific options:

```bash
aws elasticbeanstalk describe-configuration-options \
  --platform-arn YOUR_PLATFORM_ARN
```

This returns:

* All namespaces
* All option names
* Default values
* Allowed values
* Min/Max constraints

This is extremely useful for Terraform mapping.

---

# 3️⃣ Dump Your Existing Environment Config

To see exactly what your environment is currently using:

```bash
aws elasticbeanstalk describe-configuration-settings \
  --application-name dop-practise-eb-app \
  --environment-name dop-practise-eb-env \
  --profile terraform-admin \
  --region ap-southeast-1 \
  > eb-config-settings.json
```

This shows:

* Every setting currently applied
* Which namespace it belongs to
* Its current value

You can directly convert those into Terraform:

```hcl
setting {
  namespace = "aws:autoscaling:asg"
  name      = "MinSize"
  value     = "2"
}
```

---

# 🧠 Important Tip

Elastic Beanstalk has **different available settings depending on platform**:

* AL2 vs AL2023
* Java SE vs Tomcat
* Docker vs Node
* Single instance vs LoadBalanced

So always use `describe-configuration-options` for YOUR platform.

---

# 🚀 Quick Terraform Mapping Guide

If AWS CLI shows:

```json
{
  "Namespace": "aws:autoscaling:asg",
  "OptionName": "MinSize",
  "Value": "2"
}
```

Terraform equivalent:

```hcl
setting {
  namespace = "aws:autoscaling:asg"
  name      = "MinSize"
  value     = "2"
}
```

---

# 🏁 One-Line Takeaway

To see all settings:

* Official AWS docs (complete reference)
* `describe-configuration-options` (platform-specific)
* `describe-configuration-settings` (current env values)