import flatpickr from "flatpickr"
import "flatpickr/dist/flatpickr.min.css" // Note this is important!

function initPicker(dueDateString) {
  const dueDate = new Date(Date.parse(dueDateString));

  flatpickr(".datepicker", {
      dateFormat: "Y-m-d",
      onDayCreate: function(dObj, dStr, fp, dayElem) {
      // Utilize dayElem.dateObj, which is the corresponding Date

        if (dayElem.dateObj.getYear() === dueDate.getYear()
          && dayElem.dateObj.getMonth() === dueDate.getMonth()
          && dayElem.dateObj.getDate() === dueDate.getDate()) {
          dayElem.style.backgroundColor = 'pink';
        }
  }
  });
}

export { initPicker };
