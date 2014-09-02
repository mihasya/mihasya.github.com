---
layout: post
title: "Two Factor Auth: Allow AWS IAM users to manage their own MFA devices"
---

_(all info and screenshots are from 09/02/2014)_

In light of all the rescent incidents involving attackers taking control of a
company's root AWS account, myself and most everyone I know that is managing any
sort of infrastructure have been re-auditing accounts and stepping up efforts to
get everyone witin our teams to turn on MFA (multi-factor authentication).  MFA
makes it impossible for someone to log in as you with just a username/password
combo. An additional "factor" is required to confirm the user's identity -
typically a code from a synchronized number sequence. This has been standard
practice in larger companies and capital-E Enterprise for many years, and is now
starting to be taken seriously by folks operating at a smaller scale and in the
cloud. No one wants to be the [next
tragedy](http://it.slashdot.org/story/14/06/18/1513252/code-spaces-hosting-shutting-down-after-attacker-deletes-all-data)

MFA (or 2-factor auth) has traditionally been embodied by RSA tokens
attached to a keychain or a badge lanyard. These days, your phone can act as an
adequate substitute.

Turning on MFA for your root AWS account is faily easy:

<p class="center">
    <img src="/imgs/posts/awsmfa/root_mfa.png" alt="mfa device for root acct"
    class="constrained"/>
</p>

However, it took me an unfortunate amount of time to figure out how to allow
users created as IAM accounts to manage their own MFA devices. Setting people's
devices up by hand through the root account  was simply not an acceptable
solution. Even at our size it was going to be a major headache, especially
for our remote employee.

In the end, it's all documented in AWS docs, but it's a bit buried, and multiple
steps are involved. Hopefully this post saves you some time.

### Just The Right Amount

The critical thing is to give everyone JUST what they need and no more. Since
you've already secured your root account, you can likely curtail the breach of
an IAM account fairly quickly, but it's best if the account can wreak minimal
havoc in the first place. For example, if a compromised account was able to 
fiddle with the credentials of other users, the exposure and cleanup effort
would increase greatly.

Unfortunately, the IAM permissions policy system is fairly arcane. That is an
undesirable property for a security-related system to have (easy to get wrong),
but alas, it's the one we've got.

IAM Policies are made up of combinations of JSON blobs ("stanzas") each containing a
unique identifier, an effect (`Allow`, `Deny`), an action, and a resource to
which the effect/action combo should be applied. There's a whole bunch of
documentation on the subject
[here](http://docs.aws.amazon.com/IAM/latest/UserGuide/PermissionsOverview.html)
so I won't spend too much time elucidating it. Let's cut straight to what we
need.

### MFA Device Permissions

When you create an IAM user, by default they are unable to do literally
anything. When you pull up the IAM dashboard (where you have to go in order to
set up your MFA device), you literally just see permissions errors everywhere:

<p class="center">
    <img src="/imgs/posts/awsmfa/no_perms.png" alt="no permissions by default"
    class="constrained" />
</p>

"Well that sucks," I thought, looking over a co-workers shoulder. Googling
"allow IAM user to manage own mfa device," we find this lovely page:
[Example Policies for Administering IAM Resources](http://docs.aws.amazon.com/IAM/latest/UserGuide/Credentials-Permissions-examples.html)
Under the heading "Allow Users to Manage Their Own Virtual MFA Devices (AWS
Management Console)", we find an example policy that should do the trick.

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowUsersToCreateDeleteTheirOwnVirtualMFADevices",
      "Effect": "Allow",
      "Action": ["iam:*VirtualMFADevice"],
      "Resource": ["arn:aws:iam::ACCOUNT-ID-WITHOUT-HYPHENS:mfa/${aws:username}"]
    },
    {
      "Sid": "AllowUsersToEnableSyncDisableTheirOwnMFADevices",
      "Effect": "Allow",
      "Action": [
        "iam:DeactivateMFADevice",
        "iam:EnableMFADevice",
        "iam:ListMFADevices",
        "iam:ResyncMFADevice"
      ],
      "Resource": ["arn:aws:iam::ACCOUNT-ID-WITHOUT-HYPHENS:user/${aws:username}"]
    },
    {
      "Sid": "AllowUsersToListVirtualMFADevices",
      "Effect": "Allow",
      "Action": ["iam:ListVirtualMFADevices"],
      "Resource": ["arn:aws:iam::ACCOUNT-ID-WITHOUT-HYPHENS:mfa/*"]
    },
    {
      "Sid": "AllowUsersToListUsersInConsole",
      "Effect": "Allow",
      "Action": ["iam:ListUsers"],
      "Resource": ["arn:aws:iam::ACCOUNT-ID-WITHOUT-HYPHENS:user/*"]
    }
  ]
}
```                                                                                                                              }

Since this is in no way obvious, I will also note that the account ID is found
on the "Security Credentials" page of the root AWS account.

<p class="center">
    <img src="/imgs/posts/awsmfa/account_id.png" alt="aws account ids"
    class="constrained" />
</p>

This appears to be sufficient to let users find themselves in the "Users" menu,
click the "Manage MFA Device" button, and go through the rest of the process.

<p class="center">
    <img src="/imgs/posts/awsmfa/iamtestuser_mfa.png" alt="test user's mfa button"
    class="constrained" />
</p>

### Passwords etc

I also found it useful to give our users the ability to manage the rest of their
own credentials.  The relevant policy stanzas can be found
[here](http://docs.aws.amazon.com/IAM/latest/UserGuide/Credentials-Permissions-examples.html#creds-policies-credentials).

Surprisingly, the default "Password Policy" on our AWS account was set to
allow passwords as short as 6 characters with no additional requirements. Even
with MFA enabled, you'll want to crank that up to something quite a bit more
robust.

### Keeping the robots at bay

One other important aspect of our setup is the fact that only humanoid users are
able to mange their own credentials. We have a number of automation-related
"bot" accounts who have security policies tailored specifically to their
purpose - the `backup` user only has access to a specific S3 bucket, the
`dnsupdater` user only has access to a specific Route53 zone, etc. Even with
this limited set of permissions, it's important to make it difficult for an
attacker to gain control of these users. They do not have passwords, and they
are never granted permissions to manage their own credentials. This is
accomplished by attaching the policies described above to a `humans` group and
only adding users with a verified heartbeat to that group.

### Enforcing a Policy

We have a policy of not allowing access to any AWS resources without an MFA
device enabled. However a policy is only as good as its enforcement. I did a
brief google and didn't find any automated tools to do the job, though I did not
try very hard. I did find that the [AWS CLI
tool](http://aws.amazon.com/cli/) has a `aws iam get-credential-report`
command, which returns a base64-encoded CSV file containing information about
all the IAM users' credentials. One of the columns is `mfa_active`, so the data
is all there to automatically enforce an MFA policy. 

(**NB:** you have to run `aws iam generate-credential-report` beforehand. Full docs are [here](http://docs.aws.amazon.com/IAM/latest/UserGuide/credential-reports.html))

For example, the following python snippet (available as a gist
[here](https://gist.github.com/mihasya/a1fd1c4bbef04495a12b)) will parse the
contents of the report and tell you who doesn't have MFA enabled. All you have
to do is `chmod +x` the file to make it executable, then pipe the report into it
like so: `aws iam get-credential-report | ./scripts/parse_credential_report.py`.

```
#!/usr/bin/env python
from sys import stdin
import json
import base64
 
report = json.loads(stdin.read())
table = base64.b64decode(report["Content"]).splitlines()
head = table[0].split(",")
table = table[1:]
 
for row in iter(table):
    user = dict(zip(head, row.split(",")))
    # you now have a dictionary with keys like `user`, `mfa_active`,
    # and `password_last_changed`
    print "%s %s" % (user["user"], user["mfa_active"])
```

For our current team size and growth rate, and compliance needs, this is
sufficient. I did come across an example of what a fully-fleshed out tool would
look like in the the excellent [DevOps Weekly](http://devopsweekly.com/): The
Guardian's [`gu-who`](https://github.com/guardian/gu-who) for performing
account audits on GitHub accounts.
