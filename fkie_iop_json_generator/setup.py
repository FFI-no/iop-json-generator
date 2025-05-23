#!/usr/bin/env python3
import os
import sys
from distutils.core import setup
from distutils.command.build_py import build_py

package_name = 'fkie_iop_json_generator'
scripts=['scripts/jsidl2json.py']
packages=[package_name]
package_dir={'': '.'}

# install without catkin
try:
   class BuildPyCommand(build_py, object):
      def run(self):
         # honor the --dry-run flag
         if not self.dry_run:
               schema_dir = 'xsd'
               packages.append(package_name + '.jsidl_pyxb')
               # build directory should exists, create if not
               xsd_files = 'jsidl_plus_v0.xsd jsidl_plus.xsd'
               pyxbgen_exec = 'pyxbgen-py3'
               if sys.version_info[0] < 3:
                  pyxbgen_exec = 'pyxbgen-py'
               result = os.system(f'{pyxbgen_exec} -u {xsd_files} --schema-root={schema_dir} --binding-root=. --module-prefix={package_name}.jsidl_pyxb -m jsidl')
               if result != 0:
                  print(f'{pyxbgen_exec} not found, try with pyxbgen...')
                  pyxbgen_exec = 'pyxbgen'
                  result = os.system(f'{pyxbgen_exec} -u {xsd_files} --schema-root={schema_dir} --binding-root=. --module-prefix={package_name}.jsidl_pyxb -m jsidl')
                  if result != 0:
                     raise SystemError('error while execute pyxbgen\n')
         # run base class code
         super(BuildPyCommand, self).run()

   install_requires = ['python3-pyxb']
   if sys.version_info[0] < 3:
      install_requires = ['python-pyxb']

   setup(name='fkie_iop_json_generator',
         version='1.0.0',
         license='MIT',
         description='Generates JSON messages from JAUS-IDL files',
         author='Alexander Tiderko',
         author_email='alexander.tiderko@fkie.fraunhofer.de',
         url='https://github.com/FFI-no/iop-json-generator',
         install_requires=install_requires,
         cmdclass={'build_py': BuildPyCommand},
         scripts=scripts,
         packages=packages,
         package_dir=package_dir,
   )
except (ImportError, SystemError) as err:
   import sys
   sys.stderr.write(str(err))
except:
   try:
      # if we have no rights to write into src directory try to build with catkin tools
      from catkin_pkg.python_setup import generate_distutils_setup

      d = generate_distutils_setup(
         ##  don't do this unless you want a globally visible script
         scripts=scripts,
         packages=packages,
         package_dir=package_dir
      )

      setup(**d)
   except ImportError:
      import traceback
      print(traceback.format_exc())
