{ inputs, ... }:
{
  inherit
    ;
  username = "robert";
}

# README
#
# Many of the values here come from my private nix-secrets repository.
# While the primary purpose of nix-secrets is storing sensitive data
# encrypted using sops, less-senstive data are simply stored in a simple
# nix-secrets/flake.nix so they can be kept private but retrieved here
# without the overhead of sops
#
# For reference the basic example structure of my nix-secrets/flake.nix is as follows:
#
#{
#  outputs = {...}:
#    {
#        domain = "";
#        userFullName = "";
#        email = {
#            user = "";
#            work = "";
#        };
#        networking = {
#            subnets = {
#                foo = {
#                    name = "foo";
#                    ip = "0.0.0.0";
#                };
#            };
#            external = {
#                bar = {
#                    name = "bar";
#                    ip = "0.0.0.0";
#                };
#            };
#            ports = {
#                tcp = {
#                    ssh = 22;
#                };
#            };
#        };
#
#    };
#}
