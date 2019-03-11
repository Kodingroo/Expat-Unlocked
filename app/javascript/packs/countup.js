import CountUp from 'countup.js';

const counting = () => {
  const countUp = new CountUp('targetId', 5234);
  if (!countUp.error) {
    countUp.start();
  } else {
    console.error(countUp.error);
  }
};

export default counting;
