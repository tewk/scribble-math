import drawtree;


size(4cm, 0);


TreeNode root = makeNode("let");


TreeNode bindings = makeNode(root, "bindings");


TreeNode binding = makeNode(bindings, "binding");


TreeNode bid = makeNode(binding, "id");


TreeNode bexpr = makeNode(binding, "expr");


TreeNode bindingddd = makeNode(bindings, "\vphantom{bg}\dots");


TreeNode body = makeNode(root, "body");


TreeNode bodyddd = makeNode(root, "\vphantom{bg}\dots");




draw(root, (0,0));


shipout(scale(2)*currentpicture.fit());
