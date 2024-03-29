wget "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" -O /tmp/miniconda.sh
echo "# Python conda " >> /etc/rbbt_environment

bash /tmp/miniconda.sh -b -p /usr/local/miniconda3

ln -s /usr/local/miniconda3/bin/conda /usr/local/bin/conda
echo 'PATH="/usr/local/miniconda3/bin/:$PATH"' >> /etc/rbbt_environment

conda create --yes -n python2 python=2.7 pip

conda create --yes -n python3 python=3.6 pip

chmod 777 -R /usr/local/miniconda3/

echo 'PATH="/usr/local/miniconda3/envs/python2/bin/:$PATH"' >> /etc/rbbt_environment
echo 'PATH="/usr/local/miniconda3/envs/python3/bin/:$PATH"' >> /etc/rbbt_environment
echo '' >> /etc/rbbt_environment
echo '# Setup conda environment' >> /etc/rbbt_environment
echo 'export CONDA_PKGS_DIRS=~/tmp/conda/pkgs' >> /etc/rbbt_environment
echo '. /usr/local/miniconda3/etc/profile.d/conda.sh' >> /etc/rbbt_environment
echo 'conda activate python3' >> /etc/rbbt_environment

rm -Rf /usr/local/miniconda3/pkgs
. /etc/rbbt_environment

