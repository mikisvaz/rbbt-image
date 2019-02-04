wget "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" -O /tmp/miniconda.sh
bash /tmp/miniconda.sh -b -p /opt/miniconda3

[ -d /opt/bin/conda ] || mkdir -p /opt/bin/conda
ln -s /opt/miniconda3/bin/conda /opt/bin/conda

conda create --yes -n python3 python=3.6.1 pip
rm -Rf /opt/miniconda3/pkgs
conda create --yes -n python2 python=2.7 pip
rm -Rf /opt/miniconda3/pkgs

echo "# Python conda " >> /etc/rbbt_environment
echo 'export PATH="/opt/bin/:/opt/miniconda3/envs/python3/bin/:$PATH"' >> /etc/rbbt_environment

source /etc/rbbt_environment
