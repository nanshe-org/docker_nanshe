FROM jakirkham/centos_drmaa_conda:latest
MAINTAINER John Kirkham <jakirkham@gmail.com>

RUN conda config --add channels nanshe && \
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
    curl -L "https://github.com/nanshe-org/nanshe/archive/v${NANSHE_VERSION}.tar.gz" | tar -xzf - && \
    mv "/nanshe-${NANSHE_VERSION}" /nanshe && \
    cd /nanshe && \
    conda remove -y nanshe && \
    /usr/share/docker/entrypoint.sh nosetests && \
    conda install -y `find /opt/conda/pkgs -name "nanshe-${NANSHE_VERSION}-*py27*.tar.bz2"` && \
    conda clean -tipsy && \
    cd / && \
    rm -rf /nanshe
