# aws-inspector

Install and manage AWS Inspector agent.

## Usage

Add the recipe to the node or the role files where you want AWS
inspector installed. If you want to remove AWS-inspector from a
particular node, set inspector.enabled attribute to false in the node
file and it will be removed.

    ```
    {
        "name": "aws-inspector.test",
        "chef_environment": "testing",
        "run_list": [
            "recipe[aws-inspector]"
        ],
        "normal": {
            "inspector": {
                "enabled": true
            }
        }
        ...
    }
    ```

## Supported Operating Systems

- Debian Jessie
- Ubuntu
- CentOS 7
- Amazon Linux

## Depends

- apt
- yum

## Contributions

## Quality Checks

Foodcritic:
- All foodcritic recommendations followed except that I use symbols
  rather than strings to access node attributes (FC001)

    ```
    $ sudo gem install foodcritic
    $ foodcritic <path_to_recipe>
    ```

Kitchen:
- Use Kitchen to test the cookbook against a real system. Preferably an
  instance machine with Ubuntu or CentOS. Note that in `kitchen.yml`, it
  is necessary to edit `aws_ssh_key_id` and `ssh_key` to point to an SSH
  key pair in your account.

    ```
    $ bundle install
    $ kitchen test
    # =======
    $ sudo gem install test-kitchen kitchen-vagrant
    $ kitchen init
    $ kitchen diagnose --all
    ```

- Running converge
    ```
    $ kitchen converge default-ubuntu-1404
    ```

- I use `zsh` inplace of `bash`. I had to do this to make kitchen work:

    ```
    $ eval "$(chef shell-init zsh)"
    ```

TODO: Unit tests using RSpec and ChefSpec

## License

Licensed under MIT license. License text available in LICENSE.txt

While the cookbook itself is licensed under MIT, the AWS installer
script, the AWS inspector agent binary and files are licensed under
other licenses which may be more restrictive than MIT including GPLv2,
Apache, PCRE2 and BSD licenses. Please see the following file post
installation for the license text pertaining to AWS artefacts.

    /opt/aws/awsagent/LICENSE
