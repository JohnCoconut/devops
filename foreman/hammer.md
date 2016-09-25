#### hammer cheat sheet

1. authetication

hammer need to authenticate itself to foreman through foreman.yml file

```bash
cat > ~/.hammer/cli.modules.d/foreman.yml << EOF
:foreman:
    :enable_module: true
    :host: 'https://localhost/'
    :username: 'admin'
    :password: 'changeme'
EOF
```

2. import puppet class(not sure how to do it)
```bash
hammer proxy --import 
```

3. user defined types

see this reference, [http://projects.theforeman.org/projects/foreman/wiki/Instantiate_Puppet_resources](http://projects.theforeman.org/projects/foreman/wiki/Instantiate_Puppet_resources)
```bash
hammer sc-param list
hammer sc-param info --id=14
hammer sc-param update --id=14
```
