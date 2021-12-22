python initialize.py -net 'mainnet' -server 'localhost:10009' -d
python manage.py migrate
python manage.py collectstatic --no-input
supervisord
python manage.py runserver 0.0.0.0:8889