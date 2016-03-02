FROM jakirkham/centos_drmaa_conda:latest
MAINTAINER John Kirkham <jakirkham@gmail.com>

RUN conda2 config --add channels nanshe && \
    conda2 install -y --use-local -n root python=2.7 nomkl nanshe && \
    conda2 update -y --all && \
    rm -rf /opt/conda2/conda-bld/work/* && \
    conda2 remove -y -n _build --all && \
    conda2 remove -y -n _test --all && \
    cp /opt/conda2/pkgs/nanshe-*.tar.bz2 / && \
    conda2 clean -tipsy && \
    mv /nanshe-*.tar.bz2 /opt/conda2/pkgs/

RUN NANSHE_VERSION=`conda2 list -f nanshe 2>/dev/null | \
                    tail -1 | \
                    python -c "from sys import stdin; print(stdin.read().split()[1])"` && \
    curl -L "https://github.com/nanshe-org/nanshe/archive/v${NANSHE_VERSION}.tar.gz" | tar -xzf - && \
    mv "/nanshe-${NANSHE_VERSION}" /nanshe && \
    cd /nanshe && \
    conda2 remove -y nanshe && \
    /usr/share/docker/entrypoint.sh python setup.py test && \
    conda2 install -y `find /opt/conda2/pkgs -name "nanshe-${NANSHE_VERSION}-*py27*.tar.bz2"` && \
    conda2 clean -tipsy && \
    cd / && \
    rm -rf /nanshe
