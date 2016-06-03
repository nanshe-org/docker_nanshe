FROM jakirkham/centos_drmaa_conda:latest
MAINTAINER John Kirkham <jakirkham@gmail.com>

RUN for PYTHON_VERSION in 2 3; do \
        conda${PYTHON_VERSION} config --add channels conda-forge && \
        conda${PYTHON_VERSION} config --add channels nanshe && \
        conda${PYTHON_VERSION} install -y --use-local -n root nomkl nanshe && \
        conda${PYTHON_VERSION} update -y --all && \
        rm -rf /opt/conda${PYTHON_VERSION}/conda-bld/work/* && \
        conda${PYTHON_VERSION} remove -y -n _build --all && \
        conda${PYTHON_VERSION} remove -y -n _test --all && \
        NANSHE_VERSION=`conda${PYTHON_VERSION} list -f nanshe 2>/dev/null | \
                        tail -1 | \
                        python -c "from sys import stdin; print(stdin.read().split()[1])"` && \
        cp /opt/conda${PYTHON_VERSION}/pkgs/nanshe-${NANSHE_VERSION}-*.tar.bz2 / && \
        conda${PYTHON_VERSION} clean -tipsy && \
        mv /nanshe-${NANSHE_VERSION}-*.tar.bz2 /opt/conda${PYTHON_VERSION}/pkgs/ ; \
    done

RUN for PYTHON_VERSION in 2 3; do \
        NANSHE_VERSION=`conda${PYTHON_VERSION} list -f nanshe 2>/dev/null | \
                        tail -1 | \
                        python -c "from sys import stdin; print(stdin.read().split()[1])"` && \
        curl -L "https://github.com/nanshe-org/nanshe/archive/v${NANSHE_VERSION}.tar.gz" | tar -xzf - && \
        mv "/nanshe-${NANSHE_VERSION}" /nanshe && \
        cd /nanshe && \
        conda${PYTHON_VERSION} remove -y nanshe && \
        /usr/share/docker/entrypoint.sh python${PYTHON_VERSION} setup.py test && \
        conda${PYTHON_VERSION} install -y `find /opt/conda${PYTHON_VERSION}/pkgs -name "nanshe-${NANSHE_VERSION}-*.tar.bz2"` && \
        conda${PYTHON_VERSION} clean -tipsy && \
        cd / && \
        rm -rf /nanshe ; \
    done
