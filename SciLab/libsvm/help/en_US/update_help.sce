// Copyright (C) 2010 - 2011 - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

// Updates the .xml files by deleting existing files and 
// creating them again from the .sci with help_from_sci.


//
cwd = get_absolute_file_path("update_help.sce");
mprintf("Working dir = %s\n",cwd);


//
mprintf("Updating libsvm\n");
funarray = [
"libsvm_svmtrain"
"libsvm_svmpredict"
  ];
  
helpdir = fullfile(cwd,"libsvm");
macrosdir = fullfile(cwd ,"..","..","macros/help_files_sci");
demosdir = [];
modulename = "libsvm";
helptbx_helpupdate ( funarray , helpdir , macrosdir , demosdir , modulename , %t );

//
//

////////////////////////////////////////////////////////////////////////////

//
mprintf("Updating liblinear\n");
funarray = [
"libsvm_lintrain"
"libsvm_linpredict"
  ];
helpdir = fullfile(cwd,"liblinear");
macrosdir = fullfile(cwd ,"..","..","macros/help_files_sci");
demosdir = [];
modulename = "libsvm";

helptbx_helpupdate ( funarray , helpdir , macrosdir , demosdir , modulename , %t );
//
//

////////////////////////////////////////////////////////////////////////////
cwd = get_absolute_file_path("update_help.sce");
mprintf("Working dir = %s\n",cwd);
//
mprintf("Updating utilities\n");
funarray = [
  "libsvmwrite"
  "libsvmread"
  "libsvm_loadmodel"
  "libsvm_savemodel"
  ];
helpdir = fullfile(cwd,"utilities");
macrosdir = fullfile(cwd ,"..","..","macros/help_files_sci");
demosdir = [];
modulename = "libsvm";
helptbx_helpupdate ( funarray , helpdir , macrosdir , demosdir , modulename , %t );
//
//

////////////////////////////////////////////////////////////////////////////
cwd = get_absolute_file_path("update_help.sce");
mprintf("Working dir = %s\n",cwd);
//
mprintf("Updating utilities\n");
funarray = [
"libsvm_rocplot"
"libsvm_scale"
"libsvm_normalize"
"libsvm_grid"
"libsvm_confmat"
"libsvm_gridlinear"
"libsvm_partest"
"libsvm_toy"
"libsvm_getpath"
  ];
helpdir = fullfile(cwd,"utilities");
macrosdir = fullfile(cwd ,"..","..","macros");
demosdir = [];
modulename = "libsvm";
helptbx_helpupdate ( funarray , helpdir , macrosdir , demosdir , modulename , %t );
//
