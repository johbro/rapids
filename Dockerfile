#FROM rapidsai/rapidsai:0.11-cuda10.1-runtime-ubuntu18.04
FROM rapidsai/rapidsai-nightly:0.13-cuda10.2-runtime-ubuntu18.04

ENV CONDA_ENV rapids

RUN source activate $CONDA_ENV && \
    apt-get update && \
    apt-get install -y screen unzip git vim htop font-manager && \
    rm -rf /var/lib/apt/*
RUN groupadd -r nvidia
RUN useradd -r -d /rapids -g nvidia nvidia

RUN chmod -R 777 /rapids

RUN source activate $CONDA_ENV && jupyter labextension install @jupyter-widgets/jupyterlab-manager

RUN source activate $CONDA_ENV && conda install -y -c conda-forge ipyvolume && conda clean -yac *
RUN source activate $CONDA_ENV && jupyter labextension install ipyvolume

RUN source activate $CONDA_ENV && conda install -c conda-forge python-graphviz && conda clean -yac *

RUN git clone https://github.com/miroenev/rapids

# enables demo of ETL with RAPIDS and model building with DL-framework [ optional extension ]
RUN source activate $CONDA_ENV && conda install -y -c pytorch pytorch

RUN whoami
RUN pwd
RUN chown -R nvidia:nvidia /rapids

USER nvidia
ENV CONDA_ENV rapids
WORKDIR /rapids

EXPOSE 8888
# the runtime RAPIDS container automatically launches a Jupyter Lab instances on port 8888
CMD ["bash", "-c", "pkill jupyter && source activate $CONDA_ENV && jupyter lab --no-browser --ip=0.0.0.0 --NotebookApp.token=''"]
