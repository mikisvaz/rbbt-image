#!/bin/bash -x

# Prepare SLURM loopback
# ======================

cat <<'EOF' > /usr/local/bin/loopback_cmd
#!/bin/bash

if [ -z "$LOOPBACK_KEY" ]; then
  LOOPBACK_KEY="$HOME/.ssh/slurm-loopback"
fi

if [ ! -f "$LOOPBACK_KEY" ]; then
  echo "Prepare an SSH key at '$LOOPBACK_KEY' or point to it with the environment variable LOOPBACK_KEY." >&2
  exit 1
else
  ssh -i "$LOOPBACK_KEY" localhost bash -lc "'$*'"
fi
EOF


cat <<'EOF' > /usr/local/bin/squeue 
#!/bin/bash

loopback_cmd squeue "$@"
EOF


cat <<'EOF' > /usr/local/bin/sbatch 
#!/bin/bash

loopback_cmd sbatch "$@"
EOF

cat <<'EOF' > /usr/local/bin/sacct 
#!/bin/bash

loopback_cmd sacct "$@"
EOF

chmod +x /usr/local/bin/loopback_cmd /usr/local/bin/squeue /usr/local/bin/sbatch /usr/local/bin/sacct




