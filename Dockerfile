FROM jakirkham/centos_drmaa_conda:latest
MAINTAINER John Kirkham <jakirkham@gmail.com>

RUN conda config --add channels jakirkham && \
    conda install -y --use-local -n root python=2.7 nanshe && \
    conda update -y --all && \
    rm -rf /opt/conda/conda-bld/work/* && \
    conda remove -y -n _build --all && \
    conda remove -y -n _test --all && \
    cp /opt/conda/pkgs/nanshe-*.tar.bz2 / && \
    conda clean -tipsy && \
    mv /nanshe-*.tar.bz2 /opt/conda/pkgs/

RUN NANSHE_VERSION=`conda list -f nanshe 2>/dev/null | \
                    tail -1 | \
                    python -c "from sys import stdin; print(stdin.read().split()[1])"` && \
    git clone https://github.com/jakirkham/nanshe /nanshe && \
    cd /nanshe && \
    git checkout "v${NANSHE_VERSION}" && \
    conda remove -y nanshe && \
    /usr/share/docker/entrypoint.sh nosetests && \
    conda install -y nanshe && \
    cd / && \
    rm -rf /nanshe
