# Install conda packages, serparated by space

# Split CUSTOM_CONDA on commas into positional parameters
oldIFS=$IFS
IFS=',' 
set -- $CUSTOM_CONDA
IFS=$oldIFS

# Detect conda/micromamba
if command -v micromamba >/dev/null 2>&1; then
    CONDA=micromamba
elif command -v conda >/dev/null 2>&1; then
    CONDA=conda
else
    echo "Error: no conda or micromamba found" >&2
    exit 1
fi

# Loop over packages
for p in "$@"; do
    case "$p" in
        *:*)
            channel="${p%%:*}"
            package="${p##*:}"
            echo "Installing $package from channel $channel..."
            "$CONDA" install --yes -c conda-forge -c "$channel" "$package"
            ;;
        *)
            echo "Installing $p..."
            "$CONDA" install --yes -c conda-forge "$p"
            ;;
    esac
done

$CONDA clean -a
