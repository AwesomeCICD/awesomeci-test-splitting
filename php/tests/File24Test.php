<?php
use PHPUnit\Framework\TestCase;
use Demo\File24;

class File24Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File24::add(2, 3));
    }
}
