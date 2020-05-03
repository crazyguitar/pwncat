---
# https://help.github.com/en/actions/language-and-framework-guides/using-python-with-github-actions
# https://github.com/actions/python-versions/blob/master/versions-manifest.json
name: __WORKFLOW_NAME__
on:
  pull_request:
  push:
    branches:
      - master
    tags:

jobs:
  test:
    runs-on: __OS__
    strategy:
      fail-fast: False
      matrix:
        version:
          - __PYTHON_VERSION__

    name: "__JOB_NAME__"
    steps:
      # ------------------------------------------------------------
      # Setup
      # ------------------------------------------------------------
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Set up Python
        uses: actions/setup-python@v2
        with:
          python-version: ${{ matrix.version }}
          architecture: __ARCHITECTURE__

      # ------------------------------------------------------------
      # Tests: Behaviour
      # ------------------------------------------------------------

      ###
      ### Shutdown
      ###
      - name: "[BEHAVIOUR] (TCP) Client shutdown"
        shell: bash
        run: |
          make test-behaviour-tcp_client_exits_and_server_hangs_up

      - name: "[BEHAVIOUR] (UDP) Client shutdown"
        shell: bash
        run: |
          make test-behaviour-udp_client_exits_and_server_stays_alive

      - name: "[BEHAVIOUR] (TCP) Server shutdown"
        shell: bash
        run: |
          make test-behaviour-tcp_server_exits_and_hangs_up

      - name: "[BEHAVIOUR] (UDP) Server shutdown"
        shell: bash
        run: |
          make test-behaviour-udp_server_exits_and_client_stays_alive

      ###
      ### Socket
      ###
      - name: "[BEHAVIOUR] (TCP) Socket REUSEADDR"
        shell: bash
        run: |
          make test-behaviour-tcp_socket_reuseaddr

      - name: "[BEHAVIOUR] (UDP) Socket REUSEADDR"
        shell: bash
        run: |
          make test-behaviour-udp_socket_reuseaddr

      # ------------------------------------------------------------
      # Tests: Basic
      # ------------------------------------------------------------

      ###
      ### Client requests
      ###
      - name: "[BASICS] (TCP) Client makes HTTP request"
        shell: bash
        run: |
          make test-basics-client-tcp_make_http_request

      ###
      ### Client sends data/file/command to server
      ###
      - name: "[BASICS] (TCP) Client sends data to Server"
        shell: bash
        run: |
          make test-basics-client-tcp_send_text_to_server

      - name: "[BASICS] (UDP) Client sends data to Server"
        shell: bash
        run: |
          make test-basics-client-udp_send_text_to_server

      - name: "[BASICS] (TCP) Client sends file to Server"
        shell: bash
        run: |
          make test-basics-client-tcp_send_file_to_server

      - name: "[BASICS] (UDP) Client sends file to Server"
        shell: bash
        run: |
          make test-basics-client-udp_send_file_to_server

      - name: "[BASICS] (TCP) Client sends command to Server"
        shell: bash
        run: |
          make test-basics-client-tcp_send_comand_to_server

      - name: "[BASICS] (UDP) Client sends command to Server"
        shell: bash
        run: |
          make test-basics-client-udp_send_comand_to_server

      # ------------------------------------------------------------
      # Tests: Options
      # ------------------------------------------------------------

      ###
      ### DNS Resolution
      ###
      - name: "[OPTIONS] (TCP) Client --nodns"
        shell: bash
        run: |
          make test-options-client-tcp_nodns

      - name: "[OPTIONS] (UDP) Client --nodns"
        shell: bash
        run: |
          make test-options-client-udp_nodns

      ###
      ### Keep open
      ###
      - name: "[OPTIONS] (TCP) Server --keep-open"
        shell: bash
        run: |
          make test-options-tcp_server_keep_open

      # ------------------------------------------------------------
      # Tests: Modes
      # ------------------------------------------------------------

      ###
      ### Port Forward
      ###
      - name: "[MODES] (TCP) Port Forward"
        shell: bash
        run: |
          make test-modes-forwawrd_tcp-client_make_http_request
