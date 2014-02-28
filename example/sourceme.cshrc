echo "Source VCS Tool Path ..."
source /h/tool_linux/synopsys/vcs/2013.06/2013.06.cshrc
setenv UVM_HOME $VCS_HOME/etc/uvm-1.1/
setenv ROOT_DIR `pwd |grep "example" |sed "s/example.*/example/1"`
