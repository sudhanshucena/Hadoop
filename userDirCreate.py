#! /usr/bin/python
import os
import subprocess
import traceback
if __name__ == "__main__":
        filePath = raw_input('Enter a the absolute filepath for file with the list of users: ')
        if os.path.exists(filePath):
                with open(filePath, 'r') as f:
                        try:
                                for username in f:
                                        #print username.lower()
                                        try:
                                                folderHdfs='/user/'+username
                                                print "Creating user directory under /user in HDFS"
                                                subprocess.check_call(['sudo', '-u', 'hdfs', 'hdfs','dfs','-mkdir',folderHdfs])
                                                print "Changing folder Owner and Permissions"
                                                subprocess.check_call(['sudo', '-u', 'hdfs', 'hdfs','dfs','-chown',username,folderHdfs])
                                                subprocess.check_call(['sudo', '-u', 'hdfs', 'hdfs','dfs','-chmod','700',folderHdfs])
                                        except Exception, err:
                                                traceback.print_exc()
                        except:
                                print "Error occured in reading the contents of the file"
        else:
                print "Error in reading the file from the path. Please check the file path and/or its permissions"
