import React from 'react';
import ReactDOM from 'react-dom';
import 'basscss/css/basscss-cp.css';

// yup, welcome to react 16
import createReactClass from 'create-react-class';
React.createClass = createReactClass;
var Main = require('./output/MittKonto.Main/index.js');

function main() {
  const myComponent = (
    <Main.app/>
  );

  ReactDOM.render(myComponent, document.getElementById('app'));
}


if (module.hot) {
  module.hot.accept(function () {
    console.log('running main again');
    main();
  });
}

console.log('starting');
main();
