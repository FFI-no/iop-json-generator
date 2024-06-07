# only for python2, see README.md install instructions!
command -v pyxbgen >/dev/null 2>&1 || { echo >&2 "pyxbgen required but it's not installed. install python-pyxb first.  Aborting."; exit 1; }

DIR=$(dirname "$0")
if [ "$DIR" != "." ]; then
  echo "go first to the location the script located in!";
  exit 1;
fi

JSIDL_DIR=$1
if [ -z "$JSIDL_DIR" ]; then
    if [ -z "$ROS_VERSION" ]; then
      echo "no ROS_VERSION found!"
      echo "  -> use first parameter to set manually"
      exit 1
    fi
    if [ "$ROS_VERSION" = "2" ]; then
      echo "use 'ros2 pkg prefix' to find jsidls in 'fkie_iop_builder' package..."
      JSIDL_DIR=$(eval ros2 pkg prefix fkie_iop_builder)
      if [ "$JSIDL_DIR" ]; then
        JSIDL_DIR="$JSIDL_DIR/share/fkie_iop_builder/jsidl"
      fi
    elif [ "$ROS_VERSION" = "1" ]; then
      echo "use catkin_find to find jsidls in 'fkie_iop_builder' package..."
      JSIDL_DIR=$(eval catkin_find fkie_iop_builder jsidl)
    fi
    if [ -z "$JSIDL_DIR" ]; then
      echo "no path to jsidl files found!"
      echo "  -> use first parameter to set manually"
      exit 1
    fi
    echo "JSIDL found in: $JSIDL_DIR"
fi

JSON_DIR=$2
if [ -z "$JSON_DIR" ]; then
    JSON_DIR="./schemes"
    echo "use directory: $JSON_DIR"
    echo "  -> second parameter to change target direectory"
fi

echo "generate PYXB files to build/jsidl_pyxb"
GEN_DIR=build/jsidl_pyxb
mkdir -p $GEN_DIR
pyxbgen -u jsidl_plus.xsd --schema-root=xsd --binding-root=$GEN_DIR -m jsidl
touch $GEN_DIR/__init__.py

echo "generate JSON schemes from JSIDL files, write to: $JSON_DIR"
export PYTHONPATH="$PYTHONPATH:$PWD/$(dirname $GEN_DIR)/:$PWD/src/"
python3 scripts/jsidl2json.py --input_path $JSIDL_DIR --output_path $JSON_DIR --exclude urn.jaus.jss.core-v1.0

