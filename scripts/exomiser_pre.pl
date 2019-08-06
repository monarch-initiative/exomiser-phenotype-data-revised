system("wget http://compbio.charite.de/jenkins/job/hpo.annotations/lastStableBuild/artifact/misc/phenotype_annotation.tab");
open(IN,"phenotype_annotation.tab");
open(OUT1,">monarch-owlsim-data/data/Homo_sapiens/Hs_disease_phenotype.txt");
open(OUT2,">monarch-owlsim-data/data/Homo_sapiens/Hs_disease_labels.txt");
my %data;
while (my $line = <IN>){
    my @line = split(/\t/,$line);
    my $id = $line[0].":".$line[1];
    $id =~ s/ //g;
    my $label = $line[2];
    my $hp =  $line[4];
    $hp =~ s/ //g;
    $data{$id}{$label}{$hp} = 1;
}
close IN;
foreach my $id(sort keys %data){
    foreach my $label(sort keys %{$data{$id}}){
	print OUT2 "$id\t$label\n";
	foreach my $hp (sort keys %{$data{$id}{$label}}){
	    print OUT1 "$id\t$hp\n";
	}
    }
}
close OUT1;
close OUT2;
