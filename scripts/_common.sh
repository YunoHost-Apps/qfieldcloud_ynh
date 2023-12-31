#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================

pip_dependencies=(
    'ihatemoney==6.1.0'
    'gunicorn>=20.0'
    'PyMySQL>=0.9,<1.1'
	'gunicorn>=20.1.0'
	'asgiref==3.6.0'
	'attrs==21.2.0'
	'beautifulsoup4==4.12.2'
	'boto3==1.18.65'
	'boto3-stubs==1.20.26'
	'botocore==1.21.65'
	'botocore-stubs==1.23.26'
	'certifi==2021.10.8'
	'cffi==1.15.1'
	'charset-normalizer==2.0.9'
	'coreapi==2.3.3'
	'coreschema==0.0.4'
	'cryptography==36.0.1'
	'defusedxml==0.7.1'
	'Deprecated==1.2.13'
	'Django==3.2.18'
	'django-allauth==0.44.0'
	'django-appconf==1.0.5'
	'django-auditlog==2.2.2'
	'django-axes==5.40.1'
	'django-bootstrap4==23.1'
	'django-classy-tags==4.0.0'
	'django-common-helpers==0.9.2'
	'django-constance[database]==2.9.1'
	'django-countries==7.5.1'
	'django-cron==0.6.0'
	'django-cryptography==1.1'
	'django-currentuser==0.5.3'
	'django-debug-toolbar==4.1.0'
	'django-extensions==3.2.1'
	'django-filter==23.2'
	'django-invitations==2.0.0'
	'django-ipware==5.0.0'
	'django-jsonfield==1.4.1'
	'django-migrate-sql-deux==0.5.0'
	'django-model-utils==4.3.1'
	'django-nonrelated-inlines==0.2'
	'django-notifications-hq==1.7.0'
	'django-phonenumber-field==7.1.0'
	'django-picklefield==3.1'
	'django-storages==1.11.1'
	'django-log-request-id==2.1.0'
	'django-tables2==2.5.3'
	'django-timezone-field==5.0'
	'djangorestframework==3.14.0'
	'drf-spectacular==0.26.3'
	'idna==3.4'
	'inflection==0.5.1'
	'itypes==1.2.0'
	'Jinja2==3.1.2'
	'jmespath==0.10.0'
	'JSON-log-formatter==0.5.2'
	'jsonfield==3.1.0'
	'jsonschema==3.2.0'
	'MarkupSafe==2.1.2'
	'python-memcached==1.59'
	'mypy-boto3-s3==1.20.17'
	'oauthlib==3.2.2'
	'packaging==21.3'
	'phonenumbers==8.13.11'
	'psycopg2==2.8.6'
	'pycparser==2.21'
	'pydot==1.4.2'
	'PyJWT==2.7.0'
	'pyparsing==3.0.9'
	'pyrsistent==0.19.3'
	'python-dateutil==2.8.2'
	'python3-openid==3.2.0'
	'pytz==2023.3'
	'requests==2.31.0'
	'requests-oauthlib==1.3.1'
	'ruamel.yaml==0.17.26'
	'ruamel.yaml.clib==0.2.7'
	's3transfer==0.5.0'
	'sentry-sdk==1.24.0'
	'six==1.16.0'
	'soupsieve==2.4.1'
	'sqlparse==0.4.4'
	'stripe==4.2.0'
	'swapper==1.3.0'
	'typing-extensions==4.6.0'
	'tzdata==2023.3'
	'uritemplate==4.1.1'
	'urllib3==1.26.15'
	'websocket-client==1.5.2'
	'wrapt==1.15.0'
	'jsonschema>=3.2.0,<3.3'
	'typing-extensions>=3.7.4.3,<3.7.5'
	'tabulate==v0.8.9'
	'sentry-sdk'
	'requests>=2.28.1'
	'qfieldcloud-sdk==0.8.2'
)


#=================================================
# PERSONAL HELPERS
#=================================================

wait_gunicorn_start() {
    # line_match isn't enough because ihatemoney may stop if database upgrades
    for _ in {1..20}; do
        test -S /tmp/budget.gunicorn_$app.sock && break
        sleep 1
    done
}

__ynh_python_venv_setup() {
    local -A args_array=( [d]=venv_dir= [p]=packages= )
    local venv_dir
    local packages
    ynh_handle_getopts_args "$@"

    python3 -m venv --system-site-packages "$venv_dir"

    IFS=" " read -r -a pip_packages <<< "$packages"
    "$venv_dir/bin/python3" -m pip install --upgrade pip "${pip_packages[@]}"
}

__ynh_python_venv_get_site_packages_dir() {
    local -A args_array=( [d]=venv_dir= )
    local venv_dir
    ynh_handle_getopts_args "$@"

    "$venv_dir/bin/python3" -c 'import sysconfig; print(sysconfig.get_paths()["purelib"])'
}

# shellcheck disable=SC2016
HASH_PASSWORD_PYTHON='
import sys, hashlib, uuid
password = sys.argv[1].encode("utf-8")

salt_text = uuid.uuid4().hex
salt = salt_text.encode("utf-8")
pbkdf2_iterations = 600000

hash = hashlib.pbkdf2_hmac("sha256", password, salt, pbkdf2_iterations).hex()
print(f"pbkdf2:sha256:{pbkdf2_iterations}${salt_text}${hash}")
'

_hash_password() {
    password=$1
    python3 -c "$HASH_PASSWORD_PYTHON" "$password"
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
