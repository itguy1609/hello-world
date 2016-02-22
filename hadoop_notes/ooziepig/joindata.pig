cust = load 'hdfs://localhost:8020/input/custs' using PigStorage(',') as (custid:chararray, firstname:chararray, lastname:chararray,age:long,profession:chararray);

txn = load 'hdfs://localhost:8020/input/txns' using PigStorage(',') as(txnid:chararray, date:chararray,custid:chararray,amount:double,category:chararray,product:chararray,city:chararray,state:chararray,type:chararray);

txnbycust = group txn by custid;
spendbycust = foreach txnbycust generate group, SUM(txn.amount);
custorder = order spendbycust by $1 desc;
top100cust = limit custorder 100;
top100join = join top100cust by $0, cust by $0;
top100 = foreach top100join generate $0,$3,$4,$5,$6,$1;
store top100 into '/pigoutput';

