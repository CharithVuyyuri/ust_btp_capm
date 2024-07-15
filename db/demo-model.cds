using { ust.reuse as reuse } from './reuse';
using { cuid, managed, temporal  } from '@sap/cds/common';

namespace ust.demo;

context master {  //it tells that what type of data is present in the below entities.//here it is master data
  //consume address aspect to bring set of fields which are reusable
    entity student: reuse.address{  //It is like Structure/Table 
        key id: reuse.Guid;
        nameFirst: String(80);
        nameLast: String(80);
        age: Integer;
        //foreign key @runtime the column name will be class_id
        class: Association to one semester;
    }

    entity semester {
        key id: reuse.Guid;
        name: String(30);
        specialization: String(80);
        hod: String(40);
    }

    entity books{
        key code: reuse.Guid;
        name: localized String(80); 
        author: String(44);
    }
}
context transaction{
    entity subs : cuid, managed, temporal{
        student: Association to one master.student;
        book: Association to one master.books;
    }
}

