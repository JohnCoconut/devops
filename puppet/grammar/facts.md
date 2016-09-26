#### puppet 4.x facts

1. `facter`
2. `facter --puppet`
3. `puppet facts find`
4. `facter --yaml`
5. `puppet facts --render-as yaml`
6. `puppet facts --render-as json`
7. $facts['clientcert']
8. $facts['clientversion']
9. a example with facts, variable interplolation in string
```puppet
$list = ['clientcert','clientversion','clientnoop','agent_specified_environment']

$list.each |$item| {
  notice("${item} fact is:\n ${facts[$item]}")
}
```

