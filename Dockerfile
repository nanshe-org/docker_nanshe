FROM jakirkham/centos_drmaa_conda:latest
MAINTAINER John Kirkham <jakirkham@gmail.com>

RUN conda config --add channels jakirkham && \
    conda install -y --use-local -n root python=2.7 nanshe && \
    conda update -y --all && \
    rm -rf /opt/conda/conda-bld/work/* && \
    conda remove -y -n _build --all && \
    conda remove -y -n _test --all && \
    conda clean -tipsy
