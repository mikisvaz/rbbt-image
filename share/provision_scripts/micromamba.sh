# Install micromamba

curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -C /usr/ -xvj bin/micromamba

CONDA=micromamba

export MAMBA_ROOT_PREFIX=/usr/local/micromamba

micromamba create -p /usr/local/micromamba/envs/python3/ python=3.12
micromamba create -p /usr/local/micromamba/envs/python2/ python=2

echo '# Setup micromamba environment' >> /etc/rbbt_environment
echo 'export MAMBA_ROOT_PREFIX=/usr/local/micromamba' >> /etc/rbbt_environment
echo 'eval "$(/usr/bin/micromamba shell hook --shell=posix)"' >> /etc/rbbt_environment
echo 'PATH="/usr/local/micromamba/envs/python2/bin/:$PATH"' >> /etc/rbbt_environment
echo 'PATH="/usr/local/micromamba/envs/python3/bin/:$PATH"' >> /etc/rbbt_environment
#echo 'export CONDA_PKGS_DIRS=~/tmp/conda/pkgs' >> /etc/rbbt_environment
echo 'micromamba activate /usr/local/micromamba/envs/python3/' >> /etc/rbbt_environment

$CONDA clean -a
