FROM jakirkham/centos_conda:latest
MAINTAINER John Kirkham <jakirkham@gmail.com>

ENV OPENBLAS_NUM_THREADS=1

RUN for PYTHON_VERSION in 2 3; do \
        export INSTALL_CONDA_PATH="/opt/conda${PYTHON_VERSION}" && \
        . ${INSTALL_CONDA_PATH}/bin/activate root && \
        echo "tifffile 0.12.1" >> "/opt/conda${PYTHON_VERSION}/conda-meta/pinned" && \
        conda config --system --add channels nanshe && \
        conda install -qy -n root nanshe && \
        conda update -qy --all && \
        NANSHE_VERSION=`conda list -f nanshe 2>/dev/null | \
                        tail -1 | \
                        python -c "from sys import stdin; print(stdin.read().split()[1])"` && \
        cp ${INSTALL_CONDA_PATH}/pkgs/nanshe-${NANSHE_VERSION}-*.tar.bz2 / && \
        conda clean -tipsy && \
        rm -rf ~/.conda && \
        mv /nanshe-${NANSHE_VERSION}-*.tar.bz2 ${INSTALL_CONDA_PATH}/pkgs/ ; \
    done

RUN for PYTHON_VERSION in 2 3; do \
        export INSTALL_CONDA_PATH="/opt/conda${PYTHON_VERSION}" && \
        . ${INSTALL_CONDA_PATH}/bin/activate root && \
        NANSHE_VERSION=`conda list -f nanshe 2>/dev/null | \
                        tail -1 | \
                        python -c "from sys import stdin; print(stdin.read().split()[1])"` && \
        curl -L "https://github.com/nanshe-org/nanshe/archive/v${NANSHE_VERSION}.tar.gz" | tar -xzf - && \
        mv "/nanshe-${NANSHE_VERSION}" /nanshe && \
        cd /nanshe && \
        conda remove -qy nanshe && \
        /usr/share/docker/entrypoint.sh python${PYTHON_VERSION} setup.py test && \
        conda install -qy `find ${INSTALL_CONDA_PATH}/pkgs -name "nanshe-${NANSHE_VERSION}-*.tar.bz2"` && \
        conda clean -tipsy && \
        rm -rf ~/.conda && \
        cd / && \
        rm -rf /nanshe ; \
    done
