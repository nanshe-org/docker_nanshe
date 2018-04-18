FROM jakirkham/centos_conda:latest
MAINTAINER John Kirkham <jakirkham@gmail.com>

ENV OPENBLAS_NUM_THREADS=1

RUN for PYTHON_VERSION in 2 3; do \
        export INSTALL_CONDA_PATH="/opt/conda${PYTHON_VERSION}" && \
        . ${INSTALL_CONDA_PATH}/bin/activate && \
        conda config --system --add channels nanshe && \
        conda install -qy nanshe && \
        conda update -qy --all && \
        SITE_PKGS_PATH=`python -c "import site; print(site.getsitepackages()[0])"` && \
        echo 'import os; import sys; os.environ["MPLCONFIGDIR"] = os.path.join(sys.prefix, "share", "matplotlib")' >> \
             "${SITE_PKGS_PATH}/sitecustomize.py" && \
        python -c "import matplotlib; import matplotlib.pyplot" && \
        NANSHE_VERSION=`conda list -f nanshe 2>/dev/null | \
                        tail -1 | \
                        python -c "from sys import stdin; print(stdin.read().split()[1])"` && \
        cp ${INSTALL_CONDA_PATH}/pkgs/nanshe-${NANSHE_VERSION}-*.tar.bz2 / && \
        conda clean -tipsy && \
        . ${INSTALL_CONDA_PATH}/bin/deactivate && \
        rm -rf ~/.conda && \
        mv /nanshe-${NANSHE_VERSION}-*.tar.bz2 ${INSTALL_CONDA_PATH}/pkgs/ ; \
    done

RUN for PYTHON_VERSION in 2 3; do \
        export INSTALL_CONDA_PATH="/opt/conda${PYTHON_VERSION}" && \
        . ${INSTALL_CONDA_PATH}/bin/activate && \
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
        . ${INSTALL_CONDA_PATH}/bin/deactivate && \
        rm -rf ~/.conda && \
        cd / && \
        rm -rf /nanshe ; \
    done
