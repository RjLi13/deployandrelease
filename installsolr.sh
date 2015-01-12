#!/bin/bash -x
# sets up a single core solr, using solr 4.10.4 and stuff from github.
# experimental! caveat utilizator!
SOLRVERSION=solr-4.10.3
SOLRDIR=solr4
TENANT=$1
WORKINGDIR=$2
date
cd $WORKINGDIR
rm -rf $WORKINGDIR/Tools
rm -rf $WORKINGDIR/$SOLRDIR
# install solr
#curl -O http://mirror.symnds.com/software/Apache/lucene/solr/4.10.3/$SOLRVERSION.tgz
tar -xzvf $SOLRVERSION.tgz
mv $SOLRVERSION $WORKINGDIR/$SOLRDIR/
cd $WORKINGDIR/$SOLRDIR/
# we use the example core as the basis for the $TENANT core
mv example/ $TENANT
cd $TENANT/
rm -rf exampledocs/
rm -rf example-DIH/
rm -rf example-schemaless/
cd solr
mv collection1/ $TENANT-metadata
cd $WORKINGDIR/$SOLRDIR/$TENANT/solr/$TENANT-metadata/
# name the core '$TENANT-metadata'
perl -i -pe 's/collection1/$TENANT-metadata/g' core.properties
# merge in the $TENANT specific stuff (schema, etc.)
cd $WORKINGDIR
git clone https://github.com/cspace-deployment/Tools.git
cp -r Tools/datasources/ucb/multicore/$TENANT/metadata/conf/* $SOLRDIR/$TENANT/solr/$TENANT-metadata/conf/
cd $WORKINGDIR/$SOLRDIR/$TENANT
# start single core solr instance (under jetty)
nohup java -Xmx512m -jar start.jar &
