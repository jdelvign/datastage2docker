#!/bin/bash
# ---------------------------------------------------------------------------
#   Copyright 2018 Jerome Delvigne
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
# ---------------------------------------------------------------------------

docker run  --name iis-installer \
            --sysctl kernel.msgmax=65536 \
            --sysctl kernel.msgmnb=65536 \
            -p 8446:8446 \
            -h iisbox \
            --rm \
            -v //c/Users/delvignej/responsefiles:/responsefiles \
            jdelvign/iis-install:11.7
