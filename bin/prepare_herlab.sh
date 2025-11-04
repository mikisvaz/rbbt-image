/home/mvazque2/git/rbbt-image/bin/build_rbbt_provision_sh.rb --dep public.ecr.aws/amazonlinux/amazonlinux:2023 -dt rbbt-basic --base_system amazon --do base_system,tokyocabinet,slurm_loopback -sp aws-cli
/home/mvazque2/git/rbbt-image/bin/build_rbbt_provision_sh.rb --dep rbbt-basic -dt rbbt-fargate --do custom_gems,user -g mikisvaz/scout-essentials,mikisvaz/scout-gear,mikisvaz/scout-camp,mikisvaz/scout-rig,rbbt-util,rbbt-sources,rbbt-dm,scout-ai,aws-sdk-s3,nokogiri
#/home/mvazque2/git/rbbt-image/bin/build_rbbt_provision_sh.rb --dep rbbt-basic -dt rbbt-python --do python_custom -p esm
docker tag rbbt-fargate mikisvaz/rbbt-fargate:latest
docker push mikisvaz/rbbt-fargate
