<?php
use PHPUnit\Framework\TestCase;
use Demo\File33;

class File33Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File33::add(2, 3));
    }
}
